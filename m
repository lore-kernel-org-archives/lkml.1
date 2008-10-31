Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYJaLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYJaLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYJaLyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:54:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:4322 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYJaLyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jvvcFpkVJ/ja9VZ/optdpkPy48m7fZw9nH+1XrLLNDS+EiHoA7Rsi4sMzc3v7t8UtY
         SVceMINAJGFOuqezSrLM5VWJD3fHGzk93p1Uwd5dBg4eZvi3xEoij63z8I6MALyNFjRt
         H6sDtBiJTYZTuRt5A8fgTw8lSq9c2byV71zjw=
Date: Fri, 31 Oct 2008 11:53:24 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Where is asm-ia64 directory in 2.6.27 kernel?
Message-ID: <20081031115324.GB3235@hack.voiplan.pt>
References: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:45:02PM +0800, jidong xiao wrote:
>Hi,
>
>I just noticed there is no such a directory now, where are the
>including files re-located?Is it also merged into asm-x86??
>

$ ls arch/ia64/include/
asm


-- 
"Sometimes the only way to stay sane is to go a little crazy."

