Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYLEWJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYLEWJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYLEWJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:09:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:20331 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYLEWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Z46VdusnbU/1oQVTK1agxoFbVhvcw3/YUXd6jVTAyR03Rpd4Qt1da4G4fcnQo0THhZ
         IN7no/uBYdfMX/FJfe06rXk+ZCdJbtoxtosxqfkc2h/FVqzEa2QzkkIb62jJ0Z7I0CRt
         9RECkOLoZhZ4vYK+xeztgqi9SAvPk6lBi5oDM=
Message-ID: <c1e1128f0812051409rf11b30fla2a9937acba8e455@mail.gmail.com>
Date: Fri, 5 Dec 2008 16:09:45 -0600
From: "David Teigland" <dteigland@gmail.com>
Reply-To: teigland@redhat.com
To: "Peter W. Morreale" <pmorreale@novell.com>
Subject: Re: DLM configuration documentation?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1228513968.7264.86.camel@hermosa.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228513968.7264.86.camel@hermosa.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 3:52 PM, Peter W. Morreale <pmorreale@novell.com> wrote:
>
> Can someone kindly point me to documentation on configuring ...fs/dlm
> via configfs?
>
> I have found http://people.redhat.com/ccaulfie/docs/rhdlmbook.pdf
> however this doc doesn't include configuration info.

The dlm_controld utility controls the dlm; it's built on the corosync/openais
clustering framework.
http://sources.redhat.com/cluster/wiki/

Dave
