Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbYKQTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbYKQTtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYKQTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:49:37 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59377 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbYKQTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:49:36 -0500
Message-Id: <1226951375.22679.1285270059@webmail.messagingengine.com>
X-Sasl-Enc: LnmH4WB/+ZA6KgI3SpWbydTRldvcOeiRkfEFqYHJ4ffK 1226951375
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@lusi.uni-sb.de>,
       "Glauber Costa" <gcosta@redhat.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
 <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117125317.GK6703@one.firstfloor.org>
 <1226936257.32609.1285214311@webmail.messagingengine.com>
 <20081117182340.GN6703@one.firstfloor.org>
 <20081117192216.GA9944@localhost> <20081117192941.GB9944@localhost>
Subject: Re: [RFC] x86: save_args out of line
In-Reply-To: <20081117192941.GB9944@localhost>
Date: Mon, 17 Nov 2008 20:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 22:29:41 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> [Cyrill Gorcunov - Mon, Nov 17, 2008 at 10:22:16PM +0300]
> | [Andi Kleen - Mon, Nov 17, 2008 at 07:23:40PM +0100]
> | ...
> | | 
> | | Ok. Hopefully it's worth the effort. The branch misprediction bubble
> | | should not be too bad, perhaps it'll make up for the other cycles
> | | you're adding. But even if it doesn't decreasing cache line foot
> print is 
> | | always a good thing.
> | ...
> | 
> | May I turn in? :)
> |
> 
> I meant - turn into thread not "turn in" (ouch).

Even more likely is that you meant: "May I jump in" ;)

> 		- Cyrill -
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

