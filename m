Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYA3Glh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYA3Glh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYA3Gl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:41:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:38294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYA3Gl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:41:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=brBVGfqu2mrfJqwf07bQu/V28TdMVIB0Na6Pya3YZjq4t272sBN4UsImS66LPziOvo/R1b4waHkkS3WGrfz6PTN/gMwfMSvqzny7ylQ2034xtOAJoyrzKUhPW+a/Ymw+kaFM1XPsphxaL60KE4SCWEI0dv3IAqgLr2GWTgek9rU=
Message-ID: <a9cbba340801292241y1e5e553dnbcb6734e57935832@mail.gmail.com>
Date: Wed, 30 Jan 2008 14:41:24 +0800
From: "CooperYuan Cooper" <cooperyuan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: About closed-source module use GPL module function
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Now I am porting a device driver to Linux, its source code is not opened.

In this module, I use some interface functions exported from GPL
module through EXPORT_SYMBOL macros. (not EXPORT_SYMBOL_GPL), For
example, register_sound_dsp() and so on.

Do I violate GPL? How to solve it?

Thanks a lot, any suggestion is appreciated.

Cooper
