Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYDWXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYDWXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYDWXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:39:10 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35674 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYDWXjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:39:09 -0400
Date: Thu, 24 Apr 2008 01:39:04 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: iwl4965 regression since 2.6.24
Message-ID: <20080423233904.GD14412@ics.muni.cz>
References: <20080423124105.GA4783@ics.muni.cz> <D936D925018D154694D8A362EEB0892004415BC8@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D936D925018D154694D8A362EEB0892004415BC8@orsmsx416.amr.corp.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 206.196.180.225
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 24 Apr 2008 01:39:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 02:29:14PM -0700, Chatre, Reinette wrote:
> Could you please send us some logs that can help us debug this problem?
> Please load the driver with debugging (modprobe iwl4965 debug=0x43ffb)
> to get detailed logs and add a detailed description about what you are
> trying to do with the driver as the logs are created. Also, please
> consider filing a bug at http://www.intellinuxwireless.org/bugzilla/
> with these logs attached.

done at:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1659

-- 
Luká¹ Hejtmánek
