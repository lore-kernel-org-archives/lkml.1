Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXBNJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXBNJGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXBNJGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:06:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:47323 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbXBNJGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QBtLHtU40E6ZB+v5Et2De59DvBfqCQ9hzoIt1XJc5d5zOO50gMUYArp/tvQ3R6MT1Oi5v6ly/BQ9PLrlyUoxwjfKcz6xEmBf1Xs9INPCsocRAI8s5ZycnwT4hfmUTIRel4VF8OfDWYFDvr+WsCHAExPlGunmHUMTpWLjIrO+2H8=
From: Andy Parkins <andyparkins@gmail.com>
To: git@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
Date: Wed, 14 Feb 2007 09:06:35 +0000
User-Agent: KMail/1.9.5
Cc: Junio C Hamano <junkio@cox.net>, linux-kernel@vger.kernel.org
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702140906.37440.andyparkins@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2007 February 14 03:14, Junio C Hamano wrote:

>  - There is a configuration variable core.legacyheaders that

> The above two are not enabled by default and you explicitly have
> to ask for them, because these two features make repositories

It isn't really the case that you have to _enable_ legacyheaders?  It defaults 
to on already.  You actually have to disable legacyheaders.


Andy
-- 
Dr Andy Parkins, M Eng (hons), MIEE
andyparkins@gmail.com
