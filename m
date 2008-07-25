Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYGYVuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYGYVuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYGYVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:49:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:6357 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYGYVtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X7GN58Cc/6yBW3hs2esK/6BlBEz5Mqg2uTCjGguAclZ/dvAXqojWrt6pp8EWrblShV
         utYxfiUM1tw9yrtMaClnx6hGAMQr4nOa2R4c/mIYFmv5sTeu2eefCwKgkWLK0tyqn//3
         I/r8+VdOJJAmc/RdzJq6Gq42eA08RrSdVrc3A=
Message-ID: <69e28c910807251449h6e389cd2n72de63c558338335@mail.gmail.com>
Date: Fri, 25 Jul 2008 23:49:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: "=?ISO-8859-1?Q?St=E9phane_Jourdois?=" <stephane@jourdois.fr>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1216951133.2705.227.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
	 <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
	 <4885DDC4.2060609@googlemail.com> <4886235F.6010407@jourdois.fr>
	 <1216951133.2705.227.camel@debian.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/25 Zhu Yi <yi.zhu@intel.com>:
> On Tue, 2008-07-22 at 20:13 +0200, Stéphane Jourdois wrote:
>> but this commit is for iwl3945, not iwl4965.
>> The patch for iwl4965 is currently not in any git tree.
>
> We are waiting for more "confirmed success" response before merging it.
>
> Thanks,
> -yi

I think we now have a lot of "confirmed success", as aircrack-ng users
are now using this card with aireplay-ng - injecting association
frames is unstable, but injecting data packets works.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
