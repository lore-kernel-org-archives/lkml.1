Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0CJIqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:46:54 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35950 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab0CJIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=ZNDZHDwwQv88EbiQiEKF30uIzBQc6URyPAnPmAnecPXD5HMop3nnOLJzCcHfUY9u+D
         /jAo8DKrV2BJUuNJkEv88KQeczH2mtxwrVAvpdBtf1rfTTvEUYH8bhkyPxdRsvOoBQ9O
         ZXHX/r8zQ/phlmJhGKtsdQS3ntJDK8rwhpXe0=
MIME-Version: 1.0
From: Patrick Rooney <candyguitar@googlemail.com>
Date: Wed, 10 Mar 2010 08:46:30 +0000
Message-ID: <92a765341003100046o179369d4r95dd99f08bdec6bb@mail.gmail.com>
Subject: [PATCH] Staging: wlan-ng: Fixed 80-character line coding style issues 
	in p80211req.c
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com, svenne@krap.dk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d464ccd735a604816e56cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d464ccd735a604816e56cc
Content-Type: text/plain; charset=ISO-8859-1

Sorry to add this as an attachment, but copying and pasting corrupts
the patch, and git is telling me that: "git: 'send-email' is not a
git-command. See 'git --help'." (was following the instructions in
http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel; I
use Ubuntu 9.10).

--0016e6d464ccd735a604816e56cc
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-Staging-wlan-ng-Fixed-80-character-line-coding-style.patch"
Content-Disposition: attachment; 
	filename="0001-Staging-wlan-ng-Fixed-80-character-line-coding-style.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6lvcte80

RnJvbSBjOGI5NTYzNzFmNjZkNDNkZmFlMjdkZTIzZDhkYmI4YWY2MzBiOWMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDYW5keWd1aXRhciA8Y2FuZHlndWl0YXJAZ29vZ2xlbWFpbC5j
b20+CkRhdGU6IFdlZCwgMTAgTWFyIDIwMTAgMDc6NDQ6MzIgKzAwMDAKU3ViamVjdDogW1BBVENI
XSBTdGFnaW5nOiB3bGFuLW5nOiBGaXhlZCA4MC1jaGFyYWN0ZXIgbGluZSBjb2Rpbmcgc3R5bGUg
aXNzdWVzIGluIHA4MDIxMXJlcS5jCgpUaGlzIGlzIGEgcGF0Y2ggZm9yIHA4MDIxMXJlcS5jLiBB
biAnaWYnIHN0YXRlbWVudCB0aGF0IHNwYW5uZWQgODAKY2hhcmFjdGVycyBoYXMgYmVlbiBzcGxp
dCBvbnRvIDIgbGluZXMgYW5kIG9uZSBvZiB0aGUgdGFicyBwcmVjZWRpbmcKYSBjb21tZW50IGhh
cyBiZWVuIHJlbW92ZWQuCgpTaWduZWQtb2ZmLWJ5OiBQYXRyaWNrIFJvb25leSA8Y2FuZHlndWl0
YXJAZ29vZ2xlbWFpbC5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dsYW4tbmcvcDgwMjExcmVx
LmMgfCAgICA1ICsrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2xhbi1uZy9wODAyMTFyZXEu
YyBiL2RyaXZlcnMvc3RhZ2luZy93bGFuLW5nL3A4MDIxMXJlcS5jCmluZGV4IGMyZTk1ZjEuLjc0
ZTJmZTQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93bGFuLW5nL3A4MDIxMXJlcS5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93bGFuLW5nL3A4MDIxMXJlcS5jCkBAIC0xMDgsNyArMTA4LDgg
QEAgaW50IHA4MDIxMXJlcV9kb3JlcXVlc3Qod2xhbmRldmljZV90ICp3bGFuZGV2LCB1OCAqbXNn
YnVmKQogCX0KIAogCS8qIENoZWNrIFBlcm1pc3Npb25zICovCi0JaWYgKCFjYXBhYmxlKENBUF9O
RVRfQURNSU4pICYmIChtc2ctPm1zZ2NvZGUgIT0gRElEbXNnX2RvdDExcmVxX21pYmdldCkpIHsK
KwlpZiAoIWNhcGFibGUoQ0FQX05FVF9BRE1JTikgJiYKKwkobXNnLT5tc2djb2RlICE9IERJRG1z
Z19kb3QxMXJlcV9taWJnZXQpKSB7CiAJCXByaW50ayhLRVJOX0VSUgogCQkgICAgICAgIiVzOiBv
bmx5IGRvdDExcmVxX21pYmdldCBhbGxvd2VkIGZvciBub24tcm9vdC5cbiIsCiAJCSAgICAgICB3
bGFuZGV2LT5uYW1lKTsKQEAgLTEyOSw3ICsxMzAsNyBAQCBpbnQgcDgwMjExcmVxX2RvcmVxdWVz
dCh3bGFuZGV2aWNlX3QgKndsYW5kZXYsIHU4ICptc2didWYpCiAJCXdsYW5kZXYtPm1sbWVyZXF1
ZXN0KHdsYW5kZXYsIG1zZyk7CiAKIAljbGVhcl9iaXQoMSwgJih3bGFuZGV2LT5yZXF1ZXN0X3Bl
bmRpbmcpKTsKLQlyZXR1cm4gcmVzdWx0OwkJLyogaWYgcmVzdWx0PT0wLCBtc2ctPnN0YXR1cyBz
dGlsbCBtYXkgY29udGFpbiBhbiBlcnIgKi8KKwlyZXR1cm4gcmVzdWx0OwkvKiBpZiByZXN1bHQ9
PTAsIG1zZy0+c3RhdHVzIHN0aWxsIG1heSBjb250YWluIGFuIGVyciAqLwogfQogCiAvKi0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KLS0gCjEuNi4zLjMKCg==
--0016e6d464ccd735a604816e56cc--
