Return-Path: <linux-kernel-owner+w=401wt.eu-S933870AbZKXS1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbZKXS1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933758AbZKXS1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:27:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44098 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720AbZKXS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:27:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i1XAjIaeZw3NLgoTWlzJJcUqF6/vANxlFyePv/ISazJqmY88OPNhYJaBUpCTdKteLd
         oDWNuSkXuGUhI0BYJ2Hs7mDQvBjsLNIXOjWpfz8kXnL3+0IF2A3kOkP2zBUATNSQauyg
         pXBmE/gofucq/HCAS3Jy/Fxo2PtSF6JCJTF0E=
Date: Tue, 24 Nov 2009 19:27:25 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: Caleb Cushing <xenoterracide@gmail.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [E1000-devel] large packet loss take2 2.6.31.x
Message-ID: <20091124182725.GA2635@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
 <20091124111946.GA7883@ff.dom.local>
 <8DD2590731AB5D4C9DBF71A877482A903E2AA445@orsmsx509.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DD2590731AB5D4C9DBF71A877482A903E2AA445@orsmsx509.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 07:57:41AM -0800, Allan, Bruce W wrote:
> The "pci_enable_pcie_error_reporting failed" message is a non-fatal warning that has recently been removed.
> 

Thanks for the explanation,
Jarek P.
