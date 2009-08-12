Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZHLIYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZHLIYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZHLIYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:24:09 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:58765 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZHLIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OxYhjTHm3bGCAJ6zm2JxCa7XK2DcrHBBdQ3xymuD1nsSFPyZQTy5KPdIdguT6w4Toi
         6eCba6F8BHIX6r6KVqbIOlFwVfa2Vyo+KoIEt22SVR19nbbJUIhWa7X2nySM9PYtWwtz
         y1nH4PUEJ964ihK10eFifiPvjzf10oSHkX3SA=
MIME-Version: 1.0
In-Reply-To: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
Date: Wed, 12 Aug 2009 11:24:07 +0300
X-Google-Sender-Auth: 7df3a1890fb463c7
Message-ID: <84144f020908120124v5a3cab76vee1a2b09d97e15e1@mail.gmail.com>
Subject: Re: [PATCH 1/7] w35und: Commit MDS typedef to struct w35_mds
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:03 AM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Greg, the patch description should say "Convert typedef MDS to [...]".
I guess I haven't had enough coffee this morning to send out
patches...

                                               Pekka
