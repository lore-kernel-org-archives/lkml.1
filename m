Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbXE2Scg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbXE2Scg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXE2Sc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:32:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54638 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750744AbXE2Sc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:32:28 -0400
Date: Tue, 29 May 2007 11:32:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB
In-Reply-To: <465C6D4B.90403@oracle.com>
Message-ID: <Pine.LNX.4.64.0705291131010.24395@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <20070528212250.eb38af64.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705291012120.23611@schroedinger.engr.sgi.com>
 <465C6D4B.90403@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh. I forgot the usual instruction: Try to boot with slub_debug on the 
kernel command line. SLUB will attempt to remedy the situation to allow 
the boot to continue if it finds anything that goes wrong.




