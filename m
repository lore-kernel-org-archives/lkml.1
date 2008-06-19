Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbYFSPDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbYFSPDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYFSPDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:03:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:39759 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYFSPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=kzBhF4avkwDexYAMrZdXY3VzububQA84Vz8g5McTVP+chpNIbafG0pi2QXAPpDpEVJ
         fXmjwvk03EYi0wgv/JUUrD5kMugnrhCF+Us43hjE9/+WFdbeM1b7Hf1Bj/oG2xSHB6It
         PxX9Dru9/U6qbj28ZQTC2MVIEKqlnoMdLXi8M=
Date: Thu, 19 Jun 2008 17:02:48 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: zero-copy recv ?
Message-ID: <20080619150248.GA13463@slug>
References: <200806191411.m5JEBE56008942@betty.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806191411.m5JEBE56008942@betty.it.uc3m.es>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 04:11:14PM +0200, Peter T. Breuer wrote:
> G'day all
> 
> I've been mmapping the request's bio buffers received on my block device
> driver for userspace to use directly as tcp send/receive buffers.
Is the code available somewhere by any chance?
Regards,
Frederik
