Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZCJF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZCJF0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZCJF0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:26:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:57279 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZCJF0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WG3daqCqowHTI9PXU45HpV6s24jK4+2astqiR4zt4PAQ2yJaAXQ+8DZAKtnizw/8E3
         D3GWkc28Ht+YpQugzoo5YhS+rpns2PDj5MncoRFH9AjAfsQYUITsdjQIrkFku1SvJwLg
         xm+8rRSVpX2oDapyV51wCS/Wu48PberQ7P1jw=
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 22:26:33 -0700
Message-ID: <43e72e890903092226xcab8569ka959a1dcc989e3fb@mail.gmail.com>
Subject: Efforts on automatic configuration of a kernel - for lazy people
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ahmad Reza Cheraghi <a_r_cheraghi@yahoo.com>, tiwai@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm learning if there are any projects which have taken on the task of
automatically generating a kernel .config for you. I tend to hop
around machines and the routine of checking lspci, etc tends to drag
on and become more of a chore. Sometimes I just get lazy and use a
distribution's .config but that obviously is a waste of time. So I
have done some quick digging and found some effort circa 2005 by Ahmad
[1] and then Takashi's bash script [2]. Curious if there any others.

[1] http://lwn.net/Articles/153290/
[2] http://lkml.org/lkml/2008/9/16/290

  Luis
