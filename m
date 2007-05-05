Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbXEEUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbXEEUpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933404AbXEEUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:45:41 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:53224 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbXEEUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=H8rHt2EBfIMXVDlh1709mB/92Jg3BYYA+ePZ6fGDbdBRQ5NUZZeJm8/Bt43X5UrqHAzD5JO3cLPCNAnwKt5Lidq7B3MIe+1+N4ZCxN1xCky78ai0t67Uuvj1/5U6fyccgigL84x00P4+SVA0ecNMWSqifL4hjMaVtatTS5L6WuA=
Message-ID: <20cbb9450705051345t16784d28k824c9a7c38891615@mail.gmail.com>
Date: Sun, 6 May 2007 01:45:39 +0500
From: "Shahbaz Khan" <shaz.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: lxr problem - newbie needs help
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_64631_24240252.1178397939963"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_64631_24240252.1178397939963
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I am using Fedora core 6. I have configured lxr 0.3 with the latest
glimpse but I get the following in the browser:

-> Parent Directory
  -  fileidx
  -  xref

when i click the files it gives me some wierd source code with lots of
funny faces like ones in the ascii command line screens (if that makes
sense at all!).

lxr installprefix is /var/www/lxr/
My document root for apache is /var/www/
attached is my lxr configuration.

------=_Part_64631_24240252.1178397939963
Content-Type: application/octet-stream; name="lxr.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="lxr.conf"
X-Attachment-Id: f_f1cjybxj

IyBDb25maWd1cmF0aW9uIGZpbGUuCgojIERlZmluZSB0eXBlZCB2YXJpYWJsZSAidiIsIHJlYWQg
dmFsdWVzZXQgZnJvbSBmaWxlLgp2YXJpYWJsZTogdiwgVmVyc2lvbiwgWy92YXIvd3d3L2x4ci9z
b3VyY2UvdmVyc2lvbnNdLCBbL3Zhci93d3cvbHhyL3NvdXJjZS9kZWZ2ZXJzaW9uXQoKIyBEZWZp
bmUgdHlwZWQgdmFyaWFibGUgImEiLiAgRmlyc3QgdmFsdWUgaXMgZGVmYXVsdC4KdmFyaWFibGU6
IGEsIEFyY2hpdGVjdHVyZSwgKGkzODYsIGFscGhhLCBtNjhrLCBtaXBzLCBwcGMsIHNwYXJjLCBz
cGFyYzY0KQoKIyBEZWZpbmUgdGhlIGJhc2UgdXJsIGZvciB0aGUgTFhSIGZpbGVzLgpiYXNldXJs
OiBodHRwOi8vMTI3LjAuMC4xL2x4ci9odHRwLwoKIyBUaGVzZSBhcmUgdGhlIHRlbXBsYXRlcyBm
b3IgdGhlIEhUTUwgaGVhZGluZywgZGlyZWN0b3J5IGxpc3RpbmcgYW5kCiMgZm9vdGVyLCByZXNw
ZWN0aXZlbHkuCmh0bWxoZWFkOiAvdmFyL3d3dy9seHIvaHR0cC90ZW1wbGF0ZS1oZWFkCmh0bWx0
YWlsOiAvdmFyL3d3dy9seHIvaHR0cC90ZW1wbGF0ZS10YWlsCmh0bWxkaXI6ICAvdmFyL3d3dy9s
eHIvaHR0cC90ZW1wbGF0ZS1kaXIKCiMgVGhlIHNvdXJjZSBpcyBoZXJlLgpzb3VyY2Vyb290OiAv
dmFyL3d3dy9seHIvc291cmNlLyR2L2xpbnV4LwpzcmNyb290bmFtZTogTGludXgKCiMgIiNpbmNs
dWRlIDxmb28uaD4iIGlzIG1hcHBlZCB0byB0aGlzIGRpcmVjdG9yeSAoaW4gdGhlIExYUiBzb3Vy
Y2UKIyB0cmVlKQppbmNwcmVmaXg6IC9pbmNsdWRlCgojIFRoZSBkYXRhYmFzZSBmaWxlcyBnbyBo
ZXJlLgpkYmRpcjogL3Zhci93d3cvbHhyL3NvdXJjZS8kdi8KCiMgR2xpbXBzZSBjYW4gYmUgZm91
bmQgaGVyZS4KZ2xpbXBzZWJpbjogL3Vzci9sb2NhbC9iaW4vZ2xpbXBzZQoKIyBUaGUgcG93ZXIg
b2YgcmVnZXhwcy4gIFRoaXMgaXMgcHJldHR5IExpbnV4LXNwZWNpZmljLCBidXQgcXVpdGUKIyB1
c2VmdWwuICBUaW5rZXIgd2l0aCBpdCBhbmQgc2VlIHdoYXQgaXQgZG9lcy4gIChIb3cncyB0aGF0
IGZvcgojIGRvY3VtZW50YXRpb24/KQptYXA6IC9pbmNsdWRlL2FzbVteXC9dKi8gL2luY2x1ZGUv
YXNtLSRhLwptYXA6IC9hcmNoL1teXC9dKy8gL2FyY2gvJGEvCgo=
------=_Part_64631_24240252.1178397939963--
