Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZJ2PYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZJ2PYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZJ2PYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:24:18 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:59555
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZJ2PYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:24:18 -0400
Date: Thu, 29 Oct 2009 16:24:11 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091029152411.GA9300@gibson.comsick.at>
References: <20091027095014.GA22215@gibson.comsick.at>
 <200910271138.01624.elendil@planet.nl>
 <20091027140018.GF8900@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027140018.GF8900@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick update,

with patches 1+2+3+4 i STILL get the problems. I am applying patch 5 now
and report back.

/Michael
