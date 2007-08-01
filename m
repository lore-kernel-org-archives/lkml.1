Return-Path: <linux-kernel-owner+w=401wt.eu-S1765897AbXHAR4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765897AbXHAR4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXHAR4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:56:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:2255 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbXHAR4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mECNeDMg2mtFFJb6u6YnDYV9fQYM7d0X+ur4v5Z3C6nVbF+nDT/qvw8MYgmn0sc8G5MNKVU8h5HFC6MqhK8WPQ6QPaSg4gB9T3E5RKlxRcde4nQ7cJGzWpN8EpfyxMde2LlQebUWnHeK6OqtW/upYUhmyNfDUbLV2PJgRW2zpPI=
Date: Thu, 2 Aug 2007 02:56:36 +0900
From: Tejun Heo <htejun@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 026 of 35] Split any large bios that arrive at __make_request.
Message-ID: <20070801175636.GJ13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <1070731021804.25499@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021804.25499@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... Patches don't apply beyond this one.  I'm applying against
clean 2.6.23-rc1-mm1 grabbed using ketchup.

-- 
tejun
