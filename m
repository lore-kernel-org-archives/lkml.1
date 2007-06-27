Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbXF0Q07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbXF0Q07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXF0Q0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:26:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:26361 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbXF0Q0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AapXYLuIq8CgHyPyndLgXHbWVw8ls4yYyyqgxZDXqybQbqoX231WBzlpa97r5R3L4SDXSRW/nDXEes37nR2KwzuKsNJlZhx24iizWSZAtgCfTz+lCsQj41aOvW0sWOjXvcWv0ap9dKnKWbAmOOC1MKiu77DvlfmS9qgc+oAsdvo=
Message-ID: <d120d5000706270926u15ed7f78ve760e40a1f6a87e9@mail.gmail.com>
Date: Wed, 27 Jun 2007 12:26:46 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Please release a stable kernel Linux 3.0
Cc: "Adrian Bunk" <bunk@stusta.de>, "Al Boldi" <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46828B6C.6010203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706271653.58870.a1426z@gawab.com>
	 <20070627155254.GO1094@stusta.de> <46828B6C.6010203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuck,

On 6/27/07, Chuck Ebbert <cebbert@redhat.com> wrote:
>
> I was trying to figure that out for this one:
>
> http://code.ximeta.com/trac-ndas
>
> No mention of ever trying to get this upstream AFAICT... but this is
> interesting:
>
>  The linux market is limited comparing that of MS Windows.
>  it is very hard for us to support the various linux distros.
>  we, Ximeta, are trying to support those requests as many as
>  we can, though the resources are very limited.
>

I would not worry about that one too much:

[~] ls -la ndas-1.1-6/*.sfx
-rw-r--r-- 1 TOROKHDM mkgroup-l-d 60416 Jun 27 12:22 ndas-1.1-6/libndas.a.sfx

-- 
Dmitry
