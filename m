Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbXIFVyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbXIFVyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXIFVxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:53:47 -0400
Received: from main.gmane.org ([80.91.229.2]:45915 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbXIFVxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:53:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: udev: Inconsistency between %b and %p?
Date: Thu, 06 Sep 2007 23:59:10 +0200
Message-ID: <fbpsso$6bh$1@sea.gmane.org>
References: <fbp6a3$k6r$1@sea.gmane.org> <jeodgfu6pz.fsf@sykes.suse.de>	<fbppo0$rli$1@sea.gmane.org> <jelkbjfovn.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c237.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
In-Reply-To: <jelkbjfovn.fsf@sykes.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Manuel Reimer <Manuel.Spam@nurfuerspam.de> writes:
> 
>> For me, this looks like a bug, or am I wrong?
> 
> It's a feature. It's documented.

man udev says:

| The name of the device matched while searching the devpath upwards
| for SUBSYSTEMS, KERNELS, DRIVERS and ATTRS.

What exactly does this mean?

Why should anyone need the name of a device, he didn't search for?

Could someone give me an example, where someone may be interested in an 
device name of an device, he just used, to narrow his rule to the one 
device, he is looking for.

Yours

Manuel

