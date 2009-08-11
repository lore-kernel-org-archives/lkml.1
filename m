Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbZHKNhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbZHKNhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZHKNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:37:31 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18141 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZHKNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:37:30 -0400
Date: Tue, 11 Aug 2009 09:37:21 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: What happened to data=guarded? (was: ext3: Update Kconfig
 description of EXT3_DEFAULTS_TO_ORDERED)
Message-ID: <20090811133721.GD29224@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Frans Pop <elendil@planet.nl>, Theodore Ts'o <tytso@mit.edu>,
	jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
 <200908111535.37927.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908111535.37927.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A817413.0199:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
> > The old description for this configuration option was perhaps not
> > completely balanced in terms of describing the tradeoffs of using a
> > default of data=writeback vs. data=ordered.
> 
> Somewhat unrelated, but what happened to the data=guarded patches Chris 
> Mason proposed back in April?

I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
along a forward port of the patches a while back, but I finally have one
in testing here.  It should go out shortly.

-chris

