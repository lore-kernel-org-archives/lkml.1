Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbYGQGs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbYGQGs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGQGsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:48:47 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:19853 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYGQGsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:48:47 -0400
Message-ID: <fa686aa40807162348l717a5e7bt8d16b29cb89d3698@mail.gmail.com>
Date: Thu, 17 Jul 2008 00:48:44 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: petkovbb@gmail.com, jrigby@freescale.com, grant.likely@secretlab.ca,
       linux-kernel@vger.kernel.org
Subject: Re: FRED=42
In-Reply-To: <20080717063540.GA25608@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717063540.GA25608@gollum.tnic>
X-Google-Sender-Auth: 0eecf81b398f98fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:35 AM, Borislav Petkov
<petkovbb@googlemail.com> wrote:
> Hi John, Grant,
>
> can you please remove that "FRED=42" line from the top kernel Makefile since it
> seems it sneaked in unwanted with the rest of the commit?

Oh crap

Yeah, I'll fix that right now.  Sorry.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
