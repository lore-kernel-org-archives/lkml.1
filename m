Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbZL3Eoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbZL3Eoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 23:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZL3Eoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 23:44:44 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:38984 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZL3Eon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 23:44:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UE3Ta9+V7qygGnAi0P2sJD5t/uewElzS242EnfGkxt8WcDqvUSmQMsCcTtr00QUt12
         xicV+Bdd9/7Wx2Tm6SBX7edHerpUETY7pG4WP3qeuDKmUT+oAGyVdmaic1b22KvE1Jne
         txtoSY6rC45VkcA5b2uFwPiBV1YguEDDrs3ZA=
Date: Tue, 29 Dec 2009 20:44:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers/input/mouse/hgpk.c:430 unused variable 'dev'
Message-ID: <20091230044438.GE2186@core.coreip.homeip.net>
References: <4B3A9D84.5070506@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B3A9D84.5070506@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 01:23:32AM +0100, René Bolldorf wrote:
> The variable 'dev' is unused in function 'hgpk_register'.
> 
> Greeting's René Bolldorf
> 

Applied, thanks.

-- 
Dmitry
