Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYJNPzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYJNPzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYJNPzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:55:46 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34046 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYJNPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=TAVcoRUsbMEvVGaw0MtbS0iZFhFUoKo0TneIZ7O9kzuSTlBki7uw1BfNJqO6m4oOil
         BU8KcfGq3Q7pueDXbLYx5zAbTI9NF9LsNflTJQ4yyQmd+23nMq7/Mmy+KpRqYQY3yoQ2
         MQ5AmhI/FE5PzRMZic0lxGUr1urUmaJOqLCIU=
Message-ID: <5201e28f0810140855v77031cf7rbdbcaae981c7124b@mail.gmail.com>
Date: Tue, 14 Oct 2008 11:55:43 -0400
From: "Stefan Bader" <sbader3@googlemail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: [PATCH] i8042: Add Blue FB5601 to noloop exception table
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10894_13531082.1223999743490"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10894_13531082.1223999743490
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

this is another user reported Laptop which works with the noloop option.

> i have had a laptop for two years now and i have never thought that its touchpad would ever work nor at least be detected.
> until i come accross this thread. that i8042.noloop=1 option in grub was the magic!

Regards,
Stefan

------=_Part_10894_13531082.1223999743490
Content-Type: text/x-diff;
 name=0001-i8042-Add-Blue-FB5601-to-noloop-execption-table.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmapqyme0
Content-Disposition: attachment;
 filename=0001-i8042-Add-Blue-FB5601-to-noloop-execption-table.patch

RnJvbSA3OGM2ODJjODZiYzc5Y2RkM2VlN2E2ZTAzZjNkYmU3NjYzNWU0NTMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gQmFkZXIgPHN0ZWZhbi5iYWRlckBjYW5vbmljYWwu
Y29tPgpEYXRlOiBUdWUsIDE0IE9jdCAyMDA4IDExOjUwOjQ2IC0wNDAwClN1YmplY3Q6IFtQQVRD
SF0gaTgwNDI6IEFkZCBCbHVlIEZCNTYwMSB0byBub2xvb3AgZXhlY3B0aW9uIHRhYmxlLgoKU2ln
bmVkLW9mZi1ieTogU3RlZmFuIEJhZGVyIDxzdGVmYW4uYmFkZXJAY2Fub25pY2FsLmNvbT4KLS0t
CiBkcml2ZXJzL2lucHV0L3NlcmlvL2k4MDQyLXg4NmlhNjRpby5oIHwgICAgOCArKysrKysrKwog
MSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9pbnB1dC9zZXJpby9pODA0Mi14ODZpYTY0aW8uaCBiL2RyaXZlcnMvaW5w
dXQvc2VyaW8vaTgwNDIteDg2aWE2NGlvLmgKaW5kZXggNWFhZmUyNC4uZDcyNzQyMyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9pbnB1dC9zZXJpby9pODA0Mi14ODZpYTY0aW8uaAorKysgYi9kcml2ZXJz
L2lucHV0L3NlcmlvL2k4MDQyLXg4NmlhNjRpby5oCkBAIC0xMzUsNiArMTM1LDE0IEBAIHN0YXRp
YyBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBfX2luaXRkYXRhIGk4MDQyX2RtaV9ub2xvb3BfdGFibGVb
XSA9IHsKIAkJCURNSV9NQVRDSChETUlfUFJPRFVDVF9WRVJTSU9OLCAiNWEiKSwKIAkJfSwKIAl9
LAorCXsKKwkJLmlkZW50ID0gIkJsdWUgRkI1NjAxIiwKKwkJLm1hdGNoZXMgPSB7CisJCQlETUlf
TUFUQ0goRE1JX1NZU19WRU5ET1IsICJibHVlIiksCisJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1Rf
TkFNRSwgIkZCNTYwMSIpLAorCQkJRE1JX01BVENIKERNSV9QUk9EVUNUX1ZFUlNJT04sICJNNjA2
IiksCisJCX0sCisJfSwKIAl7IH0KIH07CiAKLS0gCjEuNS40LjMKCg==
------=_Part_10894_13531082.1223999743490--
