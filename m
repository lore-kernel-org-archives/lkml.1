Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYHVVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYHVVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYHVVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:15:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:28631 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbYHVVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kEeq42cCirWYLPeAaR1eTtu/xrhGMNBGpBuVVrDWjlEm6k7P7BadPMKZag+v3e+wbz
         ErgHsRrHZF1NJSkmfnZFP6g9b8O6v8/7f9DYyM5URJ20M3M0KBhBfSbCN03FTqpfy9R9
         07Fw0prGI8I82v/6XVAFq8d7lV/9/Sx43a338=
Message-ID: <56a8daef0808221415y111a8024w117e6aa8526eba7@mail.gmail.com>
Date: Fri, 22 Aug 2008 14:15:36 -0700
From: "John Ronciak" <john.ronciak@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Grant Coady" <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
       "Bruce Allan" <bruce.w.allan@intel.com>,
       "PJ Waskiewicz" <peter.p.waskiewicz.jr@intel.com>,
       "John Ronciak" <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1219435207.27921.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <1219087258.7192.19.camel@localhost>
	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>
	 <1219428489.6919.21.camel@localhost>
	 <1219428818.27921.43.camel@localhost.localdomain>
	 <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>
	 <1219435207.27921.51.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 1:00 PM, Ian Campbell <ijc@hellion.org.uk> wrote:

> So far as I can tell, yes. I can login via ssh so long as the user
> doesn't have NFS $HOME, I haven't tried much else and the box isn't
> locked up at the moment, I'd bet it's fine though.
Then it's highly unlikely that the NIC/driver is causing your problem.
 We'll continue to monitor this thread waiting for any info that this
is somehow NIC/driver related.

Good luck.



-- 
Cheers,
John
