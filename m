Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYAQATm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYAQATm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYAQATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:19:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50662 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYAQATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:19:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478E9F0A.1090002@s5r6.in-berlin.de>
Date: Thu, 17 Jan 2008 01:19:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com> <a8e1da0801150038p242c8717k9db373b1beb2404d@mail.gmail.com> <478CF710.10701@s5r6.in-berlin.de> <20080116004955.GA2929@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080116004955.GA2929@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Convert to use the class iteration api.

I'll try to review and test it at the weekend.  Thanks for patiently
going through all the patch iterations.
-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/
