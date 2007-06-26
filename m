Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbXFZJBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbXFZJBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXFZJBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:01:47 -0400
Received: from web63511.mail.re1.yahoo.com ([69.147.97.66]:48963 "HELO
	web63511.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751147AbXFZJBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:01:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=SdhJcYW/a3xspvdjhyUBKZ/JX+aFRx0srLTQMmjmy1RcZs0CPITSgzTJ6mljf12M8LmRYrCxy9Vs5nT1P3MF8GVL5FpjP0w0rhAhs+jTjg4yVD4vLFEunh35DkinTfxVgmH5m06XRT9kXsk16LGJXADYQ/QVFFjbT2asLqSx1Xk=;
X-YMail-OSG: kUDUhtEVM1lhYFynyScodAK8EBmPI2RNbEjQQamIxD.No_VOTRd.NEsIHuMwfzZDL90kzFzS6cocgEw0irH9y5iCuRrPx4ir3Z.Xysc3_P33n9E1pw4hJX15xMLM
Date: Tue, 26 Jun 2007 02:01:46 -0700 (PDT)
From: Ioannis Barkas <risc4all@yahoo.com>
Subject: [PATCH] VGA-softcursor.txt: Point at the correct directory of vgacon.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-157303694-1182848506=:94232"
Content-Transfer-Encoding: 8bit
Message-ID: <465873.94232.qm@web63511.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-157303694-1182848506=:94232
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Fixes wrong, outdated path of vgacon.c

Hello we are Ioannis Barkas (risc4all@yahoo.com) and
Nikos Barkas (doubl3nuts@yahoo.com).

VGA-softcursor.txt points to vgacon.c at a wrong
directory so we fix it.

We sent the patch from diff -u as an attachment
because damn yahoo...can't even format an inline
patch!Many thanks to "Randy Dunlap"
<randy.dunlap@oracle.com> and sorry for the
inconvenience.




 
____________________________________________________________________________________
Need Mail bonding?
Go to the Yahoo! Mail Q&A for great tips from Yahoo! Answers users.
http://answers.yahoo.com/dir/?link=list&sid=396546091
--0-157303694-1182848506=:94232
Content-Type: application/octet-stream; name="diff1.log"
Content-Transfer-Encoding: base64
Content-Description: 2640900726-diff1.log
Content-Disposition: attachment; filename="diff1.log"

LS0tIC9saW51eC0yLjYuMjEvRG9jdW1lbnRhdGlvbi9WR0Etc29mdGN1cnNv
ci50eHQJMjAwNy0wNC0yNiAwNDowODozMi4wMDAwMDAwMDAgLTA0MDAKKysr
IC9saW51eC9Eb2N1bWVudGF0aW9uL1ZHQS1zb2Z0Y3Vyc29yLnR4dAkyMDA3
LTA2LTI1IDAyOjIxOjIzLjAwMDAwMDAwMCAtMDQwMApAQCAtNCwxMSArNCwx
MSBAQAogICAgTGludXggbm93IGhhcyBzb21lIGFiaWxpdHkgdG8gbWFuaXB1
bGF0ZSBjdXJzb3IgYXBwZWFyYW5jZS4gTm9ybWFsbHksIHlvdQogY2FuIHNl
dCB0aGUgc2l6ZSBvZiBoYXJkd2FyZSBjdXJzb3IgKGFuZCBhbHNvIHdvcmsg
YXJvdW5kIHNvbWUgdWdseSBidWdzIGluCiB0aG9zZSBtaXNlcmFibGUgVHJp
ZGVudCBjYXJkcy0tc2VlICNkZWZpbmUgVFJJREVOVF9HTElUQ0ggaW4gZHJp
dmVycy92aWRlby8KLXZnYWNvbi5jKS4gWW91IGNhbiBub3cgcGxheSBhIGZl
dyBuZXcgdHJpY2tzOiAgeW91IGNhbiBtYWtlIHlvdXIgY3Vyc29yIGxvb2sK
LWxpa2UgYSBub24tYmxpbmtpbmcgcmVkIGJsb2NrLCBtYWtlIGl0IGludmVy
c2UgYmFja2dyb3VuZCBvZiB0aGUgY2hhcmFjdGVyIGl0J3MKLW92ZXIgb3Ig
dG8gaGlnaGxpZ2h0IHRoYXQgY2hhcmFjdGVyIGFuZCBzdGlsbCBjaG9vc2Ug
d2hldGhlciB0aGUgb3JpZ2luYWwKLWhhcmR3YXJlIGN1cnNvciBzaG91bGQg
cmVtYWluIHZpc2libGUgb3Igbm90LiAgVGhlcmUgbWF5IGJlIG90aGVyIHRo
aW5ncyBJIGhhdmUKLW5ldmVyIHRob3VnaHQgb2YuCitjb25zb2xlL3ZnYWNv
bi5jKS4gWW91IGNhbiBub3cgcGxheSBhIGZldyBuZXcgdHJpY2tzOiAgeW91
IGNhbiBtYWtlIHlvdXIKK2N1cnNvciBsb29rIGxpa2UgYSBub24tYmxpbmtp
bmcgcmVkIGJsb2NrLCBtYWtlIGl0IGludmVyc2UgYmFja2dyb3VuZCBvZiB0
aGUKK2NoYXJhY3RlciBpdCdzIG92ZXIgb3IgdG8gaGlnaGxpZ2h0IHRoYXQg
Y2hhcmFjdGVyIGFuZCBzdGlsbCBjaG9vc2Ugd2hldGhlcgordGhlIG9yaWdp
bmFsIGhhcmR3YXJlIGN1cnNvciBzaG91bGQgcmVtYWluIHZpc2libGUgb3Ig
bm90LiAgVGhlcmUgbWF5IGJlIG90aGVyCit0aGluZ3MgSSBoYXZlIG5ldmVy
IHRob3VnaHQgb2YuCiAKICAgIFRoZSBjdXJzb3IgYXBwZWFyYW5jZSBpcyBj
b250cm9sbGVkIGJ5IGEgIjxFU0M+Wz8xOzI7M2MiIGVzY2FwZSBzZXF1ZW5j
ZQogd2hlcmUgMSwgMiBhbmQgMyBhcmUgcGFyYW1ldGVycyBkZXNjcmliZWQg
YmVsb3cuIElmIHlvdSBvbWl0IGFueSBvZiB0aGVtLAo=

--0-157303694-1182848506=:94232--
