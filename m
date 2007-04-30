Return-Path: <linux-kernel-owner+w=401wt.eu-S1946768AbXD3U17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946768AbXD3U17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946784AbXD3U17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:27:59 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:12096 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946768AbXD3U15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pnKbcce61/6rCuqNIn6BlSo+OKKXBmzgMrauLSETKhheQIJExr0N6tJbKkmd/KP6Pf3TUeu0IjRdVveI4tpAo0E1lb1+4uOSEcSeEBOOU2j8QFHfX37dPFZMRK6dx2uvbgXqzs/Z5brjSQu1qGupasCueNYPCYtemS/4E1hWd2I=
Message-ID: <524f69650704301327x72be0ba7h17cf8ce942dd9f04@mail.gmail.com>
Date: Mon, 30 Apr 2007 15:27:57 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: UID/GID override on CIFS mounts to Samba and proposed new mount parameter to disable Unix Extensions on the client
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070430083041.d460e946.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650704300726l38c855fds49b00b9bd98360ac@mail.gmail.com>
	 <20070430083041.d460e946.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK - I fixed the formatting and checked into the cifs-2.6.git tree.  I
also fixed
a few dozen similar errors in formatting in the same files.

Thanks for noticing that.

On 4/30/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 30 Apr 2007 09:26:16 -0500 Steve French wrote:
>
> replying to the inline patch  :(
>
> Use a space between "if" and "("   (multiple occurrences).
>
> Thanks.
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>


-- 
Thanks,

Steve
