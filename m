Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYHSNnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYHSNnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYHSNnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:43:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:43312 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYHSNnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Z2D+23kSNUgc4Qm9xf/MlUMiHoQsFanxqNyAf2xlVcZ2/sJkR7Rp1vsHDdIil6Li2R
         XK1jV8ObQSM7LVdRP9WrMKxEysoUgIZE8/SepYI5NikzZLg1K4MbV6L1CvFlGRWS5IXd
         L6C+msL0a69aTHggzCYjUbNcgvgu9hJl9zyGY=
Message-ID: <ac9c93b10808190643yc7f9f1dtaf69bff474560e9@mail.gmail.com>
Date: Tue, 19 Aug 2008 15:43:22 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: openpromfs; CONFIG_SUN_OPENPROMFS; used ?? or orphaned??
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While roaming through the fs tree I bumped upon the directory openpromfs

Is this one orphaned?
I saw that the Makefile references CONFIG_SUN_OPENPROMFS, but I could not find
it in a Kconfig file nor in the .config I generated (not even a
CONFIG_SUN_OPENPROMFS not set line).
(so either it does not exist, or my eyes are getting old).

As such it does not seem too useful (unless I am overlooking things):

Two options:
- add it to some Kconfig (and note I cannot do that, I have not the
faintest idea what it is, actually I got there out of curiosity).
- rm -rf openromfs
