Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZCEMzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZCEMzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZCEMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:55:32 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46370 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZCEMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:55:32 -0500
Date: Thu, 5 Mar 2009 12:55:29 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Message-ID: <20090305125529.GB16693@silver.sucs.org>
References: <200903042020.57671.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903042020.57671.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 08:20:56PM +0100, Rolf Eike Beer wrote:
> 
> I tested several snapshots post 2.6.28 and all of them show one severe 
> problem: resume from disk is not always successful. Only about 50% of the 
> resume attempts work, in the other cases I just get a completely black 
> screen, can't switch to text console or anything. What I often get is a line 
> like this in the logs directly before suspend:

Does this happen when X hasn't been started and you suspend to disk then
resume?

-- 
Sitsofe | http://sucs.org/~sits/
