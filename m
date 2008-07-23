Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYGWXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYGWXeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYGWXeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:34:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:39027 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGWXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E/x80jZlmbCpKdCEshXYVQMPsYdrddpuKaIum6qc+kvhjez+VMWMwY/hCYmkvZVyha
         88yhBE9F6NXjR8LFKBpDgNrhkbMlG/xs2CVntxc8tlqrg6VJwMx62kocljAJ2lx3uGn7
         P8G2P/0uefF4mE/Pq7SqjcJJwhJG4zGiUnHOI=
Date: Wed, 23 Jul 2008 18:35:34 -0500
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, tytso@mit.edu, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
Message-ID: <20080723233534.GA9975@localhost>
References: <20080723214938.GA8034@mit.edu> <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com> <20080723225820.GA4099@localhost> <20080723.161100.219406395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723.161100.219406395.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23.Jul'08 at 16:11:00 -0700, David Miller wrote:
> From: "Carlos R. Mafra" <crmafra2@gmail.com>
> Date: Wed, 23 Jul 2008 17:59:06 -0500
> 
> > I am trying to bisect it, but I am facing some difficulties with compilation
> > problems and non-booting kernels.
> 
> We know what the problem is and are discussing it on netdev
> and linux-wireless already.

Thank you for letting me know, David!
I appreciate that deeply.
