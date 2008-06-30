Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYF3PYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYF3PYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYF3PYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:24:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:47023 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYF3PYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GBYyhvtPvu3hk2z9bWqpL+m/+FSeUmhY6CbcTkEE4RrneRvNT8XF+nCAVIqKd7nzP2
         sndtzIN923eXvtrtNREx90B996xSXERB3HlJpTjiNA9c2SeKHgz3gckttamXxoulzG0F
         ddIgUSqbGJfEM91he5xHgqYRyamBVS5RDS4PA=
Date: Mon, 30 Jun 2008 11:24:31 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WM9712: Warn if user attempts to use pressure
	measurement with 5 wire mode
Message-ID: <20080630112353.ZZRA012@mailhub.coreip.homeip.net>
References: <1214829325-5414-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214829325-5414-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jun 30, 2008 at 01:35:25PM +0100, Mark Brown wrote:
> This is not supported by the hardware.
> 

Applied to the 'next' tree, thank you.

-- 
Dmitry
