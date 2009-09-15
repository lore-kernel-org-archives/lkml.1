Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZIOPcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZIOPcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZIOPcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:32:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50544 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZIOPcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d4XyNHLyHnQLeGUZVi9H6xwXayVWDUVcqsH05yW5QOxNFsY6vwW4hAzcyQqfMY9nLu
         S729VoPIu/+4wLasYOhOOiVJKx2Yd4XXla7bCdPq59wewmheHYkAngvIUwRU6Taz15pS
         GsxtOhJ40/t+/KRrm6zELuCEzCfz5gw9x1RjA=
Date: Tue, 15 Sep 2009 17:32:24 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090915153224.GB26806@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915120538.GA26806@bizet.domek.prywatny>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 02:05:38PM +0200, Karol Lewandowski wrote:
> This is on 2.6.31-rc9 (with unrelated patch reverted), 2.6.31-rc8
> shown similiar behaviour. Neither 2.6.31 nor Linus' HEAD seems to
> address this issue.

I shall add that on 2.6.30 (and earlier) this issue didn't happen.
