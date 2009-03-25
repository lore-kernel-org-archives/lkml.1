Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZCYB3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZCYB3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZCYB3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:29:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:3199 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZCYB3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=w3PpFX9Lz+vE9lTmmMNLyr3vbuUpqomKGvMyiC0/aCi7CWpF7Ze0rBfMTqjkJHr9qI
         2GTAqVe2pydEu12rmjWQqUkqtU+qUKkG4x+dh9SQ4Hv2iS8i4JzSgADnxGjP0AYWI+GH
         19M97zLEY7KkDSv40EKOLi+BgE9nycNTwD+8I=
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 12:28:55 +1100
Message-ID: <25ae2d690903241828p5549f525neae980ac22cea979@mail.gmail.com>
Subject: PATCH Re: misspelling on line 1190 of net/ipv4/udp.c .
From: db <db.pub.mail@gmail.com>
To: justinmattock@gmail.com
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: multipart/mixed; boundary=000e0cd2e1dc2aa88d0465e76d64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2e1dc2aa88d0465e76d64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2009/3/25  <justinmattock@gmail.com>:
> On Tue, 24 Mar 2009, db wrote:
>
>> Hi, i think there is a misspelling of the =C2=A0word checksumming (if it
>> is an actual =C2=A0word ^^) on line 1190 of net/ipv4/udp.c .
>>
>> The line reads, " * Otherwise, csum completion requires chacksumming
>> packet body,"
>>
>> Perhaps the line can be changed to "* Otherwise, csum completion
>> requires a checksum of the packet body".
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>
>
>
> Well.
> What are you waiting for, submit a patch. :^)
>
> regards,
>
> -- Justin P. Mattock
>

Ok i have made an attempt, haven't done this before ^^ . Please let me
know if i have done something wrong.

--000e0cd2e1dc2aa88d0465e76d64
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fspc5so20

LS0tIGxpbnV4LTIuNi4yOS9uZXQvaXB2NC91ZHAuYy5vcmlnCTIwMDktMDMtMjUgMTI6MjM6MDUu
MDAwMDAwMDAwICsxMTAwCisrKyBsaW51eC0yLjYuMjkvbmV0L2lwdjQvdWRwLmMJMjAwOS0wMy0y
NSAxMjoyNDo0Ni4wMDAwMDAwMDAgKzExMDAKQEAgLTExODcsNyArMTE4Nyw3IEBAIHN0YXRpYyBp
bnQgX191ZHA0X2xpYl9tY2FzdF9kZWxpdmVyKHN0cnUKIAogLyogSW5pdGlhbGl6ZSBVRFAgY2hl
Y2tzdW0uIElmIGV4aXRlZCB3aXRoIHplcm8gdmFsdWUgKHN1Y2Nlc3MpLAogICogQ0hFQ0tTVU1f
VU5ORUNFU1NBUlkgbWVhbnMsIHRoYXQgbm8gbW9yZSBjaGVja3MgYXJlIHJlcXVpcmVkLgotICog
T3RoZXJ3aXNlLCBjc3VtIGNvbXBsZXRpb24gcmVxdWlyZXMgY2hhY2tzdW1taW5nIHBhY2tldCBi
b2R5LAorICogT3RoZXJ3aXNlLCBjc3VtIGNvbXBsZXRpb24gcmVxdWlyZXMgYSBjaGVja3N1bSBv
ZiB0aGUgcGFja2V0IGJvZHksCiAgKiBpbmNsdWRpbmcgdWRwIGhlYWRlciBhbmQgZm9sZGluZyBp
dCB0byBza2ItPmNzdW0uCiAgKi8KIHN0YXRpYyBpbmxpbmUgaW50IHVkcDRfY3N1bV9pbml0KHN0
cnVjdCBza19idWZmICpza2IsIHN0cnVjdCB1ZHBoZHIgKnVoLAo=
--000e0cd2e1dc2aa88d0465e76d64--
