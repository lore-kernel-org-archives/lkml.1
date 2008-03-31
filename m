Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYCaUtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYCaUtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYCaUtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:49:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:54603 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYCaUtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DOQpk/QRAGQUBCsLDr3jHEXlTKsJwlyebwJo+XXfAxlgzykWeUrIO/7zgKdL0V0sHWACUOkLhkhXVW2r6potD/8d1YBRKywC9yu8sVTwxp5mQOH6kLn7X/pYMiWX059D/ZwFfDFdzkk5lpWn6V2VRrh4LuSNhIrpBKQNxeHe4gI=
Message-ID: <84144f020803311349w7f1b83e8x174ada25ffc85215@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:49:16 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [RFC PATCH] UBIFS - new flash file system
Cc: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
In-Reply-To: <20080331171757.GA2077@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
	 <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org>
	 <47F0EE63.3060401@nokia.com> <20080331171757.GA2077@logfs.org>
X-Google-Sender-Auth: 38900fb9e090f9c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 31 March 2008 17:00:03 +0300, Artem Bityutskiy wrote:
> > I personally refuse to compare a finished FS with handles all the
> > crucial flash features to a non-finished FS. It just makes no sense.

On Mon, Mar 31, 2008 at 8:17 PM, Jörn Engel <joern@logfs.org> wrote:
>  Noone is forcing you.

There are some of us that are interested to know why we want UBIFS in
the mainline rather than wait for LogFS or some other variant to
appear though.

                        Pekka
