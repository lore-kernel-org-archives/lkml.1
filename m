Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXCTO3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXCTO3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXCTO3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:29:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56486 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbXCTO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:29:52 -0400
Subject: Re: user defined hotplug events?
From: Arjan van de Ven <arjan@infradead.org>
To: balagi@justmail.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1HTaAr-0007r6-B0@www10.emo.freenet-rz.de>
References: <E1HTaAr-0007r6-B0@www10.emo.freenet-rz.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Mar 2007 15:28:05 +0100
Message-Id: <1174400885.1158.81.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Or new, user defined, ones?

there's always the "CHANGED" event.. it's very very generic and just
means "check my state for new stuff"....


