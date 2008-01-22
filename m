Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYAVPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYAVPGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYAVPF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:05:56 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:64861 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYAVPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:05:56 -0500
X-IronPort-AV: E=Sophos;i="4.25,233,1199685600"; 
   d="scan'208";a="552018246"
Date: Tue, 22 Jan 2008 09:02:51 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: william cheng <opensourcewill@gmail.com>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobing ipmi_si on Dell Power Edge 2600 make the terminal hang kernel ver. >= 2.6.20
Message-ID: <20080122150251.GA4403@auslistsprd01.us.dell.com>
References: <7d34f9680801201740u4eb912eel921e7890b4ac023a@mail.gmail.com> <20080122125031.GA23330@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122125031.GA23330@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 06:50:31AM -0600, Matt Domsch wrote:
> On Mon, Jan 21, 2008 at 09:40:59AM +0800, william cheng wrote:
> > Dear all,
> > 
> >         We got some problem on modprobing the ipmi_si module on Dell
> > Power Edge 2600.
> 
> I've asked someone to look into this.

and I've filed this as
http://bugzilla.kernel.org/show_bug.cgi?id=9793

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
