Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXF0AMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXF0AMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXF0AMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:12:33 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:53326 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXF0AMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:12:32 -0400
Date: Wed, 27 Jun 2007 01:12:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [drm patch for 2.6.22-rc6] Add some pci ids for XGI chips
Message-ID: <Pine.LNX.4.64.0706270111110.17520@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1978455807-1182903151=:17520"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1978455807-1182903151=:17520
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


The attached patch just adds some XGI pci ids to the SIS driver. It should 
be harmless at this stage..

Dave.
--29444707-1978455807-1182903151=:17520
Content-Type: TEXT/plain; charset=US-ASCII; name=0001-Add-support-SiS-based-XGI-chips-to-SiS-DRM.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0706270112310.17520@skynet.skynet.ie>
Content-Description: 
Content-Disposition: attachment; filename=0001-Add-support-SiS-based-XGI-chips-to-SiS-DRM.txt

RnJvbSAwMjAzMWJmOTE5MGY2Njk4ZTQ2ZTE1NzE5NjA4NmZmNDE2ZDBiZjli
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogSWFuIFJvbWFuaWNr
IDxpZHJAdXMuaWJtLmNvbT4NCkRhdGU6IFdlZCwgMjcgSnVuIDIwMDcgMDY6
Mzg6MDAgKzEwMDANClN1YmplY3Q6IFtQQVRDSF0gQWRkIHN1cHBvcnQgU2lT
IGJhc2VkIFhHSSBjaGlwcyB0byBTaVMgRFJNLg0KDQpUaGlzIGFkZHMgc3Vw
cG9ydCBmb3Igc29tZSBvZiB0aGUgWEdJIFZvbGFyaSBmYW1pbHkgdGhhdCBh
cmUgYmFzZWQgb24gdGhlDQpTaVMuDQoNClNpZ25lZC1vZmYtYnk6IERhdmUg
QWlybGllIDxhaXJsaWVkQGxpbnV4LmllPg0KLS0tDQogZHJpdmVycy9jaGFy
L2RybS9kcm1fcGNpaWRzLmggfCAgICAyICsrDQogZHJpdmVycy9jaGFyL2Ry
bS9zaXNfZHJ2LmggICAgfCAgICA4ICsrKystLS0tDQogMiBmaWxlcyBjaGFu
Z2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2NoYXIvZHJtL2RybV9wY2lpZHMuaCBiL2RyaXZl
cnMvY2hhci9kcm0vZHJtX3BjaWlkcy5oDQppbmRleCBhYTYzMzUwLi4zMGIy
MDBiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jaGFyL2RybS9kcm1fcGNpaWRz
LmgNCisrKyBiL2RyaXZlcnMvY2hhci9kcm0vZHJtX3BjaWlkcy5oDQpAQCAt
MjE5LDYgKzIxOSw4IEBADQogCXsweDEwMzksIDB4NjMwMCwgUENJX0FOWV9J
RCwgUENJX0FOWV9JRCwgMCwgMCwgMH0sIFwNCiAJezB4MTAzOSwgMHg2MzMw
LCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCBTSVNfQ0hJUF8zMTV9
LCBcDQogCXsweDEwMzksIDB4NzMwMCwgUENJX0FOWV9JRCwgUENJX0FOWV9J
RCwgMCwgMCwgMH0sIFwNCisJezB4MThDQSwgMHgwMDQwLCBQQ0lfQU5ZX0lE
LCBQQ0lfQU5ZX0lELCAwLCAwLCBTSVNfQ0hJUF8zMTV9LCBcDQorCXsweDE4
Q0EsIDB4MDA0MiwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgU0lT
X0NISVBfMzE1fSwgXA0KIAl7MCwgMCwgMH0NCiANCiAjZGVmaW5lIHRkZnhf
UENJX0lEUyBcDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2RybS9zaXNf
ZHJ2LmggYi9kcml2ZXJzL2NoYXIvZHJtL3Npc19kcnYuaA0KaW5kZXggMmI4
ZDZmNi4uNzBkNGVkZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY2hhci9kcm0v
c2lzX2Rydi5oDQorKysgYi9kcml2ZXJzL2NoYXIvZHJtL3Npc19kcnYuaA0K
QEAgLTMzLDExICszMywxMSBAQA0KIA0KICNkZWZpbmUgRFJJVkVSX0FVVEhP
UgkJIlNJUywgVHVuZ3N0ZW4gR3JhcGhpY3MiDQogI2RlZmluZSBEUklWRVJf
TkFNRQkJInNpcyINCi0jZGVmaW5lIERSSVZFUl9ERVNDCQkiU0lTIDMwMC82
MzAvNTQwIg0KLSNkZWZpbmUgRFJJVkVSX0RBVEUJCSIyMDA2MDcwNCINCisj
ZGVmaW5lIERSSVZFUl9ERVNDCQkiU0lTIDMwMC82MzAvNTQwIGFuZCBYR0kg
VjNYRS9WNS9WOCINCisjZGVmaW5lIERSSVZFUl9EQVRFCQkiMjAwNzA2MjYi
DQogI2RlZmluZSBEUklWRVJfTUFKT1IJCTENCi0jZGVmaW5lIERSSVZFUl9N
SU5PUgkJMg0KLSNkZWZpbmUgRFJJVkVSX1BBVENITEVWRUwJMQ0KKyNkZWZp
bmUgRFJJVkVSX01JTk9SCQkzDQorI2RlZmluZSBEUklWRVJfUEFUQ0hMRVZF
TAkwDQogDQogZW51bSBzaXNfZmFtaWx5IHsNCiAJU0lTX09USEVSID0gMCwN
Ci0tIA0KMS40LjQuMg0KDQo=

--29444707-1978455807-1182903151=:17520--
