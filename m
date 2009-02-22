Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZBVGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZBVGRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 01:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZBVGRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 01:17:16 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:53837 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZBVGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 01:17:15 -0500
MIME-Version: 1.0
Date: Sun, 22 Feb 2009 01:17:14 -0500
X-Google-Sender-Auth: 9683f9b27dd3954c
Message-ID: <5aa163d00902212217s6a2414f2heea1712abaa45f02@mail.gmail.com>
Subject: PATCH [1/2] Documentation/driver-model/device.txt: fix struct 
	device_attribute
From: Mike Murphy <mamurph@cs.clemson.edu>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
Content-Type: multipart/mixed; boundary=0016e64601e65443f004637bd611
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64601e65443f004637bd611
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Fix the presented definition of struct device_attribute to match the
actual definition in include/linux/device.h

Signed-off-by: Mike Murphy <mamurph[at]cs.clemson.edu>

--0016e64601e65443f004637bd611
Content-Type: text/x-patch; charset=US-ASCII; name="device.patch"
Content-Disposition: attachment; filename="device.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frhbt8p40

LS0tIGxpbnV4LTIuNi4yOC41L0RvY3VtZW50YXRpb24vZHJpdmVyLW1vZGVsL2RldmljZS50eHQJ
MjAwOS0wMi0xMiAxMjo1MToxNS4wMDAwMDAwMDAgLTA1MDAKKysrIGRvY2ZpeC9Eb2N1bWVudGF0
aW9uL2RyaXZlci1tb2RlbC9kZXZpY2UudHh0CTIwMDktMDItMjIgMDA6NDI6NTguMDAwMDAwMDAw
IC0wNTAwCkBAIC0xMjcsOSArMTI3LDExIEBACiBBdHRyaWJ1dGVzCiB+fn5+fn5+fn5+CiBzdHJ1
Y3QgZGV2aWNlX2F0dHJpYnV0ZSB7Ci0gICAgICAgIHN0cnVjdCBhdHRyaWJ1dGUgICAgICAgIGF0
dHI7Ci0gICAgICAgIHNzaXplX3QgKCpzaG93KShzdHJ1Y3QgZGV2aWNlICogZGV2LCBjaGFyICog
YnVmLCBzaXplX3QgY291bnQsIGxvZmZfdCBvZmYpOwotICAgICAgICBzc2l6ZV90ICgqc3RvcmUp
KHN0cnVjdCBkZXZpY2UgKiBkZXYsIGNvbnN0IGNoYXIgKiBidWYsIHNpemVfdCBjb3VudCwgbG9m
Zl90IG9mZik7CisJc3RydWN0IGF0dHJpYnV0ZQlhdHRyOworCXNzaXplX3QgKCpzaG93KShzdHJ1
Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLAorCQkJY2hhciAq
YnVmKTsKKwlzc2l6ZV90ICgqc3RvcmUpKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpOwog
fTsKIAogQXR0cmlidXRlcyBvZiBkZXZpY2VzIGNhbiBiZSBleHBvcnRlZCB2aWEgZHJpdmVycyB1
c2luZyBhIHNpbXBsZQo=
--0016e64601e65443f004637bd611--
