Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXLGOUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXLGOUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGOUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:20:03 -0500
Received: from mail.ukpost.com ([217.158.120.132]:39679 "EHLO mail.ukpost.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXLGOUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:20:03 -0500
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Dell ik8 
Date: Fri, 07 Dec 2007 14:19:31 +0000
X-Mailer: IlohaMail/0.8.11 (On: www.ukfsn.org)
From: "Nick Warne" <nick@ukfsn.org>
Bounce-To: "Nick Warne" <nick@ukfsn.org>
Cc: "dz@debian.org" <dz@debian.org>
MIME-Version: 1.0 
Content-Type: multipart/mixed; boundary="RWP_PART_nick1197037171"
Message-Id: <20071207141931.4B068A31A0@mail.ukpost.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--RWP_PART_nick1197037171
Content-Type: text/plain; charset="UTF-8"

This small patch adds the Dell UK 6400 Inspiron model (MM061) to allow
the i8k module to load correctly without using 'force=1'

signed-off-by:  "Nick Warne" <nick@ukfsn.org>

Nick

--RWP_PART_nick1197037171
Content-Type: text/x-patch; name="i8k.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="i8k.patch"

LS0tIGk4ay5jT1JJRwkyMDA3LTEyLTA3IDEwOjMwOjQyLjAwMDAwMDAwMCArMDAwMAorKysgaThr
LmMJMjAwNy0xMi0wNyAxMzoxMDo1Ny4wMDAwMDAwMDAgKzAwMDAKQEAgLTQzOSw2ICs0MzksMTMg
QEAKIAkJCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAiTGF0aXR1ZGUiKSwKIAkJfSwKIAl9
LAorCXsJLyogVUsgSW5zcGlyb24gNjQwMCAgKi8KKwkJLmlkZW50ID0gIkRlbGwgSW5zcGlyb24g
MyIsIAorCQkubWF0Y2hlcyA9IHsKKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkRlbGwg
SW5jLiIpLAorCQkJRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJNTTA2MSIpLAorCQl9LAor
CX0sCiAJeyB9CiB9OwogCg==

--RWP_PART_nick1197037171--

