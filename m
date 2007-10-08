Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbXJHS10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbXJHS10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXJHS1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:27:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51825 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbXJHS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:27:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470A7650.2030803@s5r6.in-berlin.de>
Date: Mon, 08 Oct 2007 20:26:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org> <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 8 2007 19:37, Sam Ravnborg wrote:
>> snip...
>>
>> Or maybe we need something much less formal that explain the purpose of the
>> four tags we use:
> 
> At least formal try:
> 
>> Signed-of-by:
> 
> * Used by original submitter(s).
> * Also used by maintainers to track the patch's path
>   (ATM, does not imply "I have look at it in depth")

Signed-off-by (as far as the Developer's Certificate of Origin defines
it) says:  I made sure that this patch complies with all involved licenses.
-- 
Stefan Richter
-=====-=-=== =-=- -=---
http://arcgraph.de/sr/
