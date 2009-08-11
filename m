Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZHKNfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZHKNfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZHKNfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:35:39 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:63142 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbZHKNfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:35:39 -0400
From: Frans Pop <elendil@planet.nl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: What happened to data=guarded? (was: ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED)
Date: Tue, 11 Aug 2009 15:35:36 +0200
User-Agent: KMail/1.9.9
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
In-reply-To: <1249934623-15939-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111535.37927.elendil@planet.nl>
X-OriginalArrivalTime: 11 Aug 2009 13:35:38.0369 (UTC) FILETIME=[9CE63F10:01CA1A88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The old description for this configuration option was perhaps not
> completely balanced in terms of describing the tradeoffs of using a
> default of data=writeback vs. data=ordered.

Somewhat unrelated, but what happened to the data=guarded patches Chris 
Mason proposed back in April?

Cheers,
FJP
