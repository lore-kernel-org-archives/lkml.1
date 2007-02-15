Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXBOBzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXBOBzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964822AbXBOBzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:55:15 -0500
Received: from main.gmane.org ([80.91.229.2]:49846 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXBOBzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:55:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jakub Narebski <jnareb@gmail.com>
Subject: Re: [ANNOUNCE] GIT 1.5.0
Followup-To: gmane.comp.version-control.git
Date: Thu, 15 Feb 2007 02:55:10 +0100
Organization: At home
Message-ID: <er0eee$6qp$1@sea.gmane.org>
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-81-190-26-5.torun.mm.pl
Mail-Copies-To: Jakub Narebski <jnareb@gmail.com>
User-Agent: KNode/0.10.2
Cc: git@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:

>  - git-blame learned a new option, --incremental, that tells it
>    to output the blames as they are assigned.  A sample script
>    to use it is also included as contrib/blameview.

And there are example GUI blameview (Perk GTK2), and example Emacs module
for incremental git-blame, both in contib/ area. 

-- 
Jakub Narebski
Warsaw, Poland
ShadeHawk on #git


