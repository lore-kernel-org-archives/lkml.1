Return-Path: <linux-kernel-owner+w=401wt.eu-S1764994AbYD1GK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764994AbYD1GK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYD1GKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:10:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:50101 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYD1GKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZJgHbGU29ngqRgCHASwXS9fRmsLINtK2wxZg12Ou+3aHgyot/v4wcnuOnJUcI9RzH4ccdQ8o4553bmW7af0yzkTw11194YFXq/QM7bLAZpNmCmvIJNlCP5cUWypx8gOhibl7vAXiki+iPsKP+KIZGBGWRadWpKNWCetyiM/qbFI=
Message-ID: <e2e108260804272310r7aa99a91x204aeac5418fb25e@mail.gmail.com>
Date: Mon, 28 Apr 2008 08:10:10 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ken Moffat" <zarniwhoop@ntlworld.com>
Subject: Re: 2.6.25 slow boot/reboot
Cc: "Sergio Luis" <sergio@larces.uece.br>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080427235554.GA28344@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48141111.7010605@larces.uece.br>
	 <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
	 <20080427235554.GA28344@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 1:55 AM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>   But, I think you (Bart) haven't said which version of lilo you are
>  using ?  If it isn't recent, perhaps upgrading it might help ?

I noticed the slow loading behavior of LILO after a fresh install of
Ubuntu 8.04 beta with XFS as root file system. I did not check the
version number. Should I look it up ?

Bart.
