Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbYB1WnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbYB1WnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYB1WnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:43:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:41282 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYB1WnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ue78JW8TQiRfzn7nSbor5iJr55RFJL1KFSem9hPO3C8Y2a/yXbwz/yec5+ClPSVH/Vhhh2Sq6s4uVaOuT2IewhF+D/lC1faiLRH2I0bQbsusR7K1zKVZC7PpK8D6W4XyZFASDnKSWbYh7cqUZTYAQCIT3eHH23sTU8sWN6r/FLg=
Message-ID: <9a8748490802281443v62252343y5987e432df9462bd@mail.gmail.com>
Date: Thu, 28 Feb 2008 23:43:15 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: cpuset trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org, clameter@sgi.com,
       menage@google.com
In-Reply-To: <20080219073450.7479cb00.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219193503.94A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080219073450.7479cb00.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2008, Paul Jackson <pj@sgi.com> wrote:
> KOSAKI-san wrote:
>  > +++ b/Documentation/cpusets.txt 2008-02-19 19:37:14.000000000 +0900
>
> > ...
>
> > -automatically tracks the value of node_states[N_MEMORY]--i.e.,
>  > +automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
>
>
> Thanks.
>
>  Acked-by: Paul Jackson <pj@sgi.com>
>

If no one else picks this up, I'll submit it to Linus via the trivial
tree when the next merge window opens.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
