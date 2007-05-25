Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXEYV1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXEYV1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXEYV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:27:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXEYV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:27:27 -0400
Message-ID: <46575492.1080107@zytor.com>
Date: Fri, 25 May 2007 14:26:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [CodingStyle] Add comment to not put spaces before
 tabs.
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <46571DA8.1000402@s5r6.in-berlin.de> <46573C70.2070209@zytor.com> <4657473A.6020203@intel.com>
In-Reply-To: <4657473A.6020203@intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> 
> ahh yes, I'll incorporate that.
> 
> BTW, would it be possible for cleanfile/cleanpatch to dump warnings to
> stderr for lines exceeding 80 characters? I think that would really be
> useful...
> 

Should be trivial enough to do, although it probably should be an option.

	-hpa
