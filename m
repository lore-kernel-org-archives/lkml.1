Return-Path: <linux-kernel-owner+w=401wt.eu-S936965AbXGZUR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936965AbXGZUR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936434AbXGZUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:16:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60810 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936695AbXGZUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=N9NSpuz9YxXs/RqAKAzbG0jpEYsgAWGh8e2LhmWRL44lLLkWaSYIc1wJ80tEKOjpNZCfWr0DNy+LAxSBC8iMRYNA92i8cHGErCCLaH8ei3hQ9UUNlpdvwVWmkBFnVScAUkGW7QzhNq+ysOKPRglrP7dOSVGSPMD3sU8UtV0Jxmw=
Message-ID: <86802c440707261316w324e90f8kce855e34424b2199@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:16:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 05/05] x86_64: family 10h and 11h to k8topology
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_205848_27608282.1185480977315"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_205848_27608282.1185480977315
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_205848_27608282.1185480977315
Content-Type: text/x-patch; name=apicid_to_node_5.diff; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4louvs4
Content-Disposition: attachment; filename="apicid_to_node_5.diff"

W1BBVENIIDA1LzA1XSB4ODZfNjQ6IGZhbWlseSAxMGggYW5kIDExaCB0byBrOHRvcG9sb2d5CgpG
cm9tOiAiSm9hY2hpbSBEZWd1YXJhIiA8am9hY2hpbS5kZWd1YXJhQGFtZC5jb20+ClRoaXMganVz
dCBhZGRzIHRoZSBQQ0kgSURzIG9mIEFNRCdzIGZhbWlseSAxMGggYW5kIDExaCBDUFUncyBub3J0
aGJyaWRnZXMgdG8Kazh0b3BvbG9neSBkaXNjb3ZlcnkuCgpTaWduZWQtb2ZmLWJ5OiBKb2FjaGlt
IERlZ3VhcmEgPGpvYWNoaW0uZGVndWFyYUBhbWQuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRpIEts
ZWVuIDxha0BzdXNlLmRlPgpBY2tlZC1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaS5sdUBzdW4uY29t
PgoKIGFyY2gveDg2XzY0L21tL2s4dG9wb2xvZ3kuYyB8ICAgIDggKysrKysrLS0KIDEgZmlsZSBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgotLS0gYS9hcmNoL3g4Nl82
NC9tbS9rOHRvcG9sb2d5LmMJMjAwNy0wNy0yMyAxMToxNDo0Ni4wMDAwMDAwMDAgLTA3MDAKKysr
IGIvYXJjaC94ODZfNjQvbW0vazh0b3BvbG9neS5jCTIwMDctMDctMjMgMTE6MTc6MjAuMDAwMDAw
MDAwIC0wNzAwCkBAIC0yOCwxMSArMjgsMTUgQEAKIAkJdTMyIGhlYWRlcjsKIAkJCiAJCWhlYWRl
ciA9IHJlYWRfcGNpX2NvbmZpZygwLCBudW0sIDAsIDB4MDApOyAgCi0JCWlmIChoZWFkZXIgIT0g
KFBDSV9WRU5ET1JfSURfQU1EIHwgKDB4MTEwMDw8MTYpKSkKKwkJaWYgKChoZWFkZXIgIT0gKFBD
SV9WRU5ET1JfSURfQU1EIHwgKDB4MTEwMDw8MTYpKSkgJiYKKwkJICAgIChoZWFkZXIgIT0gKFBD
SV9WRU5ET1JfSURfQU1EIHwgKDB4MTIwMDw8MTYpKSkgJiYKKwkJICAgIChoZWFkZXIgIT0gKFBD
SV9WRU5ET1JfSURfQU1EIHwgKDB4MTMwMDw8MTYpKSkpCiAJCQljb250aW51ZTsgCQogCiAJCWhl
YWRlciA9IHJlYWRfcGNpX2NvbmZpZygwLCBudW0sIDEsIDB4MDApOyAKLQkJaWYgKGhlYWRlciAh
PSAoUENJX1ZFTkRPUl9JRF9BTUQgfCAoMHgxMTAxPDwxNikpKQorCQlpZiAoKGhlYWRlciAhPSAo
UENJX1ZFTkRPUl9JRF9BTUQgfCAoMHgxMTAxPDwxNikpKSAmJgorCQkgICAgKGhlYWRlciAhPSAo
UENJX1ZFTkRPUl9JRF9BTUQgfCAoMHgxMjAxPDwxNikpKSAmJgorCQkgICAgKGhlYWRlciAhPSAo
UENJX1ZFTkRPUl9JRF9BTUQgfCAoMHgxMzAxPDwxNikpKSkKIAkJCWNvbnRpbnVlOwkKIAkJcmV0
dXJuIG51bTsgCiAJfSAK
------=_Part_205848_27608282.1185480977315--
