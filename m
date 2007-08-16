Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXHPMBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXHPMBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXHPMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:01:29 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:51801 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXHPMB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:01:28 -0400
Message-ID: <46C43BA3.6090807@gmail.com>
Date: Thu, 16 Aug 2007 13:57:23 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Salikh Zakirov <salikh@gmail.com>
CC: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org> <20070814193333.GI21089@ftp.linux.org.uk> <46C2548D.80605@gmail.com> <alpine.LFD.0.999.0708151846130.16414@enigma.security.iitk.ac.in> <46C30220.6060007@gmail.com> <68B09015-4411-470A-BA88-732969469AA2@mac.com> <46C42DCB.1060502@gmail.com> <46C43015.7080804@gmail.com> <fa1c95$sv6$1@sea.gmane.org>
In-Reply-To: <fa1c95$sv6$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2007 01:26 PM, Salikh Zakirov wrote:

Please don't drop CCs.

> Rene Herman wrote:
>> Perhaps that immediately suggests an implementation to someone already
>> familiar with git internals?
> 
> perhaps http://www.kernel.org/pub/software/scm/git/docs/gitattributes.html
> and http://www.kernel.org/pub/software/scm/git/docs/git-check-attr.html
> can help you?

No, thanks, saw them, but .gitattributes is in fact in the same category as 
.gitignore, which would _be_ a property.

If you do this stuff in files scattered around the tree, updating and moving 
stuff becomes a pain -- the tool would need to go edit files.

Rene.



