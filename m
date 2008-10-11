Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYJKDSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYJKDSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 23:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYJKDSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 23:18:14 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:43155 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYJKDSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 23:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PBPGfeDQOQnHW2eeKhUY/FUwdrAH0wCw1ZQfV3ZMjDBRvZZqphd2jxTruVS9QfxQYM
         gPMEAAXM01VvDi4EBl6fqvlJKNZri9r6QNSYBKYq3DkBM9hpX5JC8AMm+J5SsdO7dM9A
         jnEz/2tQOmxN+S9bI07gDRuzpo80JBRa5laHA=
Date: Fri, 10 Oct 2008 23:18:09 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Henk.Vergonet@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] input: Move map_to_7segment.h to include/linux (v2)
Message-ID: <20081011031809.GA22499@anvil.corenet.prv>
References: <20081010.144217.106262895.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010.144217.106262895.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 02:42:17PM +0900, Atsushi Nemoto wrote:
> The map_to_7segment.h provides generic 7segment LED mappings and is
> designed to be used by other drivers.  Moving it to common area will
> make it more usable.  Also exporting it to userspace will help users
> of sysfs interface.
> 

Applied, thank you Atsushi.

-- 
Dmitry
