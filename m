Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXCMOEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXCMOEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXCMOEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:04:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35847 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030301AbXCMOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:04:38 -0400
Date: Tue, 13 Mar 2007 19:41:37 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Kirill Korotaev <dev@sw.ru>, menage@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 1/2] rcfs core patch
Message-ID: <20070313141137.GD19939@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <20070308101347.GA29051@in.ibm.com> <20070309004816.GB4506@MAIL.13thfloor.at> <45F127AB.5070704@sw.ru> <20070309132136.GA14907@MAIL.13thfloor.at> <45F437C9.2090108@sw.ru> <20070312230053.GD21258@MAIL.13thfloor.at> <45F66096.20900@sw.ru> <20070313135505.GD8755@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313135505.GD8755@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 02:55:05PM +0100, Herbert Poetzl wrote:
> yes, tons of locking, complicated indirections and
> a lot of (partially hard to understand) code ...

Are you referring to these issues in the general Paul Menage's container code
or in the RSS-control code posted by Pavel?

-- 
Regards,
vatsa
