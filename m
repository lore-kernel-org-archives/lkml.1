Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZBMXXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZBMXXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZBMXXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:23:33 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58572 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbZBMXXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:23:33 -0500
Message-Id: <1234567411.13034.1300286953@webmail.messagingengine.com>
X-Sasl-Enc: CcD0OcJ9JBMrJK3ZA9YaNkQx9YgbksPZyWwA+UssmVD0 1234567411
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jan Beulich" <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
In-Reply-To: <20090213215017.959278111@gmail.com>
Date: Sat, 14 Feb 2009 00:23:31 +0100
References: <20090213215017.959278111@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 14 Feb 2009 00:50:17 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> Hi,
> 
> here is a small series of cleanups for assembler
> files. Not sure if introducing new GLOBAL macro
> was a good idea but code got shorter form of
> writting.
> 
> Please review. Any comments are highly appreciated.

Hi Cyrill,

I like this direction. If I understand correctly:

ENTRY/END or GLOBAL/END for data.
ENTRY/ENDPROC or GLOBAL/ENDPROC for functions.

The patches look sound. You're welcome to add:

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

Greetings,
    Alexander

> Cyrill
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access your email from home and the web

