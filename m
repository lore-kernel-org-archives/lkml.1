Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbZEHAgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbZEHAgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbZEHALH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:11:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:43244 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbZEHALG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YhSdD0XnrPRroK5rbuJZwEd+YGb9ppv25sGuu/PnICxkmMcIvHLCuWCH94UxnjAoHg
         NxML9bH7KaUTVKTBxJ9YAb9nKx2vJjI+zTqaQHT3eXxliOOVr9gSpaVAfygXm5IBa6ir
         8JedENBVnqOIGUVqMwkX5hp+OsmEHpGLHfYVI=
MIME-Version: 1.0
In-Reply-To: <4A03129A.90105@acm.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507120948.GA1531@ucw.cz> <4A03129A.90105@acm.org>
Date: Thu, 7 May 2009 17:11:05 -0700
Message-ID: <faa09fad0905071711v788e847dr33cf5a2eb688c1cc@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Alex Goebel <alex.goebel@gmail.com>
To: U Kuehn <ukuehn@acm.org>
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@tuxonice.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Given that tuxonice DOES work reliably with dm-crypt encrypted swap
> partitions, does uswsusp offer this functionality? Looking into the docs
> on the sourceforge site does not give any information about this point.

Works here. Just tried (s2disk, vanilla 2.6.29). It also claims you
can hit "Del" to abort and to that it compressed the image.

Alex
