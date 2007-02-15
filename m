Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXBOF0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXBOF0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbXBOF0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:26:20 -0500
Received: from corvette.plexpod.net ([64.38.20.226]:33204 "EHLO
	corvette.plexpod.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbXBOF0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:26:19 -0500
X-Greylist: delayed 11702 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 00:26:19 EST
Date: Wed, 14 Feb 2007 21:11:13 -0500
From: "Shawn O. Pearce" <spearce@spearce.org>
To: Jakub Narebski <jnareb@gmail.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
Message-ID: <20070215021113.GA29732@spearce.org>
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net> <er0eee$6qp$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <er0eee$6qp$1@sea.gmane.org>
User-Agent: Mutt/1.5.11
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - corvette.plexpod.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - spearce.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Narebski <jnareb@gmail.com> wrote:
> Junio C Hamano wrote:
> 
> >  - git-blame learned a new option, --incremental, that tells it
> >    to output the blames as they are assigned.  A sample script
> >    to use it is also included as contrib/blameview.
> 
> And there are example GUI blameview (Perk GTK2), and example Emacs module
> for incremental git-blame, both in contib/ area. 

Not to mention the incremental blame viewer built into git-gui:

	git gui blame HEAD foo.c

-- 
Shawn.
