Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYHOTDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYHOTDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYHOTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:03:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:42708 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831AbYHOTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yo78nGC6noaRdhWqW89HXSnCrF7mYas8RFXD/TPimc72MMRckR8ohwZWxnWkvxKPOG
         jdcvlxMgb72WrQCpTo58IrtvDU9zejXtAvJFZMgYMd8YHxwj4O6wJ9ly496+qxD6ovHx
         JB+nZS3UrNT4oie614mk/gfYRaUt6NoNTni/A=
Date: Fri, 15 Aug 2008 15:03:23 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-input@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] Input/keyboard: add uctional power management
	support to Blackfin BF54x keypad driver
Message-ID: <20080815150301.ZZRA012@mailhub.coreip.homeip.net>
References: <1218790959-12694-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218790959-12694-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 05:02:39PM +0800, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Fix Bug: does nor properply resume after suspend mem
> Fix for PM_SUSPEND_MEM: Save and restore peripheral base registers
> 

Applied to 'next', thank you.

-- 
Dmitry
