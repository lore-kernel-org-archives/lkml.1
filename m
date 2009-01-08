Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZAHJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZAHJrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZAHJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:47:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:47975 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAHJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d3HMDZMxV+VeLC6zFnlH6OJaK44jheFLcVms73ZdNbsMouo5G55P6izumo3TdbV8+E
         R9wWw18TvW14gCrk9cSMz85nfk+cBHhR+E6M+EtHVEAWV1xvDfEIaPZBrSxTttWkwqTq
         HposISBd0mcRDIaXP9+FtOEfpl0vReowEJ8w0=
Subject: Re: [PATCH 1/3] w35und: Move ETH_LENGTH_OF_ADDRESS to wbhal_s.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 01:46:58 -0800
Message-Id: <1231408018.5539.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 11:30 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>  
> +#define ETH_LENGTH_OF_ADDRESS 6

Or just use ETH_ALEN like the rest of the kernel and drop this guy.

Harvey

