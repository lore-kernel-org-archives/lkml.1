Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZLDBNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZLDBNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZLDBNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:13:36 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:36224 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZLDBNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TGIqbR9M1NDQEXkiPe7W7wdGuW/c6mq/lCwPwbfrx5p7HPh3SnE9M0O1IPC8ErizTZ
         RaSVk4fsiZUJXuca0TWwV66uQLWGlkthEUqoZ3S15mv9q7BLwOOOFdlttDBYWLqRj5Xr
         g/Aw4m/mt/TIGnyNOG1766n3On1He1uf56nW8=
MIME-Version: 1.0
In-Reply-To: <4B185D32.1090207@goop.org>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-4-git-send-email-konrad.wilk@oracle.com>
	 <45a44e480912031635t331f7433v3003dd36cfd9940@mail.gmail.com>
	 <4B185D32.1090207@goop.org>
Date: Fri, 4 Dec 2009 09:13:42 +0800
Message-ID: <45a44e480912031713s3b81dc13h3b6c545e09adb558@mail.gmail.com>
Subject: Re: [PATCH 3/3] fb-defio: Inhibit VM_IO flag to be set on vmalloc-ed 
	framebuffers.
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, damm@opensource.se,
       linux-kernel@vger.kernel.org, armbru@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 8:52 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> Thanks.  Are you OK with me sending to Linus, or do you have a tree you'd
> prefer it to go by?
>

Thanks Jeremy, yes, please feel free to send.
