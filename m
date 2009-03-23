Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZCWHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZCWHP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZCWHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:15:45 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48689 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZCWHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xr7OAWPOhDGBAbFtYFOBDmY3HsjxBWQadTj8eK4te03HFJXiO3/Ftpgxix5htPW9pc
         zK4IKZEUpquHI/s94yu7uSMJYWfSWCe3NrjGvcOIxUd4YHEcfz9xLJ1n5iKBIrpWtQ7u
         jD+1jFIX/cWQ7jwj35byzedJqjXMdpOCIl51c=
Date: Mon, 23 Mar 2009 08:15:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090323071538.GA5944@nowhere>
References: <200903231208.03723.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903231208.03723.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 12:08:03PM +0530, Nikanth Karthikesan wrote:
> Hi
> 
> I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always seem to
> get empty trace! Am I doing something wrong?


Hi Nikanth,

Does latest -tip tree work for you with about the same config?

http://people.redhat.com/mingo/tip.git/readme.txt

Thanks,
Frederic.

