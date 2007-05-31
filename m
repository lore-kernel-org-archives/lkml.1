Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXEaAgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXEaAgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXEaAf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:35:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:47611 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXEaAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZUhkQbtKCPp2xPzXlgUfA9MXQYRsgQkkgCzrmCApcwuw2FuEk1sjotyqkMr24oKmOmNV9f3mfk1mIatM093LSXZrSFHJ1Q3w4zc4G7YvwZbylwzChfWVYMI5KsRQFhLom4JZEB0QezQNVIl5ihYaCgXo2iqi1HN4tPkJi0jztTI=
Message-ID: <a8e1da0705301735r5619f79axcb3ea6c7dd344efc@mail.gmail.com>
Date: Thu, 31 May 2007 00:35:56 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20070531003012.302019683@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070531002047.702473071@sgi.com>
	 <20070531003012.302019683@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

>Introduce CONFIG_STABLE to control checks only useful for development.

What about control checks only as SLUB_DEBUG is set?

Regards
dave
