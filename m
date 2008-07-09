Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYGIURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYGIURl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYGIURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:17:33 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:42067 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYGIURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:17:32 -0400
X-Authority-Analysis: v=1.0 c=1 a=fmkApugzUIIA:10 a=kpXAE35kjxYA:10
 a=Gd4cTaxRV00yGMmUSfMA:9 a=IjfyhiiTBtMpruk5M8LU-ENuWzwA:4 a=JTUSPwgBgNAA:10
 a=oCUJXWGl-OwA:10
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       linux-kernel@vger.kernel.org, linux-uvc-devel@berlios.de
Subject: Re: Linux 2.6.26-rc9 circular lock with uvcvideo on resume from hibernation
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <1215426867.5113.8.camel@pern>
	<200807092129.03679.laurent.pinchart@skynet.be>
	<87mykq96mh.fsf@shaolin.home.digitalvampire.org>
	<200807092210.56678.laurent.pinchart@skynet.be>
From: Roland Dreier <roland@digitalvampire.org>
Date: Wed, 09 Jul 2008 13:17:27 -0700
In-Reply-To: <200807092210.56678.laurent.pinchart@skynet.be> (Laurent Pinchart's message of "Wed, 9 Jul 2008 22:10:56 +0200")
Message-ID: <87hcay95ig.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Have you checked David's videodev patch ? Any opinion ?

Not yet... I'll search for it.
-- 

Roland Dreier  <roland@digitalvampire.org>  GPG Key: 1024D/E0EEFAC0
Fingerprint:     A89F B5E9 C185 F34D BD50  4009 37E2 25CC E0EE FAC0

 Sending >500KB attachments is forbidden by the Geneva Convention.
        Your country may be at risk if you fail to comply.
