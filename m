Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZHKOyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZHKOyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZHKOyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:54:39 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:65400 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062AbZHKOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:54:38 -0400
From: Frans Pop <elendil@planet.nl>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 16:54:36 +0200
User-Agent: KMail/1.9.9
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think>
In-Reply-To: <20090811133721.GD29224@think>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111654.38217.elendil@planet.nl>
X-OriginalArrivalTime: 11 Aug 2009 14:54:38.0648 (UTC) FILETIME=[A6536B80:01CA1A93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 August 2009, Chris Mason wrote:
> On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
> > Somewhat unrelated, but what happened to the data=guarded patches
> > Chris Mason proposed back in April?
>
> I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
> along a forward port of the patches a while back, but I finally have
> one in testing here.  It should go out shortly.

Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
data=guarded over data=writeback. I'll certainly give it a try when it's 
available.

Thanks,
FJP
